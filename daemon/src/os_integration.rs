use winapi::um::sysinfoapi::GetTickCount64;
use winapi::um::winuser::{GetLastInputInfo, LASTINPUTINFO};
use std::mem;
use std::collections::HashMap;
use wmi::{COMLibrary, WMIConnection, Variant};

pub fn get_idle_time_ms() -> Option<u64> {
    unsafe {
        let mut lii: LASTINPUTINFO = mem::zeroed();
        lii.cbSize = mem::size_of::<LASTINPUTINFO>() as u32;

        if GetLastInputInfo(&mut lii) != 0 {
            let current_tick = GetTickCount64();
            let last_input_tick = lii.dwTime as u64;
            
            if current_tick >= last_input_tick {
                return Some(current_tick - last_input_tick);
            }
        }
    }
    None
}

pub fn is_system_idle_for_mins(minutes: u64) -> bool {
    if let Some(idle_ms) = get_idle_time_ms() {
        return idle_ms >= (minutes * 60 * 1000);
    }
    false
}

// WMI Process Monitoring
pub fn is_process_running(process_name: &str) -> bool {
    println!("Checking if process {} is running via WMI...", process_name);
    
    let com_con = match COMLibrary::new() {
        Ok(com) => com,
        Err(_) => return false,
    };
    
    let wmi_con = match WMIConnection::new(com_con) {
        Ok(wmi) => wmi,
        Err(_) => return false,
    };
    
    let query = format!("SELECT Name FROM Win32_Process WHERE Name = '{}'", process_name);
    let results: Result<Vec<HashMap<String, Variant>>, _> = wmi_con.raw_query(&query);
    
    match results {
        Ok(processes) => !processes.is_empty(),
        Err(_) => false,
    }
}
