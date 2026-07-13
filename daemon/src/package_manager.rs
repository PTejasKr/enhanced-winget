use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct AppVersion {
    pub repo: String,
    pub version: String,
}

pub trait PackageManager {
    fn name(&self) -> &str;
    fn get_available_updates(&self) -> Vec<AppVersion>;
}

pub struct WingetManager;
impl PackageManager for WingetManager {
    fn name(&self) -> &str { "winget" }
    
    fn get_available_updates(&self) -> Vec<AppVersion> {
        // Mock implementation
        vec![AppVersion { repo: self.name().to_string(), version: "1.0.9015".to_string() }]
    }
}

pub struct ScoopManager;
impl PackageManager for ScoopManager {
    fn name(&self) -> &str { "scoop" }
    
    fn get_available_updates(&self) -> Vec<AppVersion> {
        // Mock implementation
        vec![AppVersion { repo: self.name().to_string(), version: "1.0.9016".to_string() }]
    }
}

pub struct ChocoManager;
impl PackageManager for ChocoManager {
    fn name(&self) -> &str { "chocolatey" }
    
    fn get_available_updates(&self) -> Vec<AppVersion> {
        // Mock implementation
        vec![AppVersion { repo: self.name().to_string(), version: "1.0.9015".to_string() }]
    }
}
