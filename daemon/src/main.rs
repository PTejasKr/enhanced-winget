mod package_manager;
mod os_integration;

use futures_util::{SinkExt, StreamExt};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use tokio_tungstenite::{connect_async, tungstenite::protocol::Message};
use url::Url;
use winrt_notification::{Duration, Sound, Toast};

use package_manager::{PackageManager, WingetManager, ScoopManager, ChocoManager};

#[derive(Serialize, Deserialize)]
struct UpdateQuery {
    app_name: String,
    versions: Vec<package_manager::AppVersion>,
}

#[tokio::main]
async fn main() {
    println!("Starting Ew Local Daemon (Rust)...");

    let url = Url::parse("ws://localhost:8000/ws/updates").unwrap();
    
    let (ws_stream, _) = match connect_async(url).await {
        Ok(stream) => stream,
        Err(e) => {
            eprintln!("Failed to connect to Cloud Brain: {}", e);
            return;
        }
    };
    
    println!("WebSocket connected");

    let (mut write, mut read) = ws_stream.split();

    let managers: Vec<Box<dyn PackageManager>> = vec![
        Box::new(WingetManager),
        Box::new(ScoopManager),
        Box::new(ChocoManager),
    ];

    let mut all_versions = Vec::new();
    for manager in managers {
        all_versions.extend(manager.get_available_updates());
    }

    let query = UpdateQuery {
        app_name: "Discord".to_string(),
        versions: all_versions,
    };

    let payload = serde_json::to_string(&query).unwrap();
    println!("Sending: {}", payload);
    write.send(Message::Text(payload)).await.unwrap();

    if let Some(msg) = read.next().await {
        if let Ok(message) = msg {
            if message.is_text() {
                let response = message.to_text().unwrap();
                println!("Received decision: {}", response);
                
                if let Ok(decision_val) = serde_json::from_str::<Value>(response) {
                    let app = decision_val["App"].as_str().unwrap_or("Unknown App");
                    let decision = decision_val["Decision"].as_str().unwrap_or("");
                    let sentiment = decision_val["Sentiment"].as_i64().unwrap_or(0);
                    
                    if sentiment >= 70 && sentiment < 90 {
                        // Tier 2: Toast Notification
                        Toast::new(Toast::POWERSHELL_APP_ID)
                            .title(&format!("Update Available: {}", app))
                            .text1(&format!("AI Sentiment: {}%. Should we install?", sentiment))
                            .sound(Some(Sound::SMS))
                            .duration(Duration::Short)
                            .show()
                            .expect("Failed to show toast notification");
                    } else if sentiment >= 90 {
                        // Tier 1: Silent auto-install
                        if os_integration::is_system_idle_for_mins(15) {
                            println!("System is idle. Executing silent install for {}...", app);
                        } else {
                            println!("System is not idle. Queueing silent install for {}...", app);
                        }
                    }
                }
            }
        }
    }
}
