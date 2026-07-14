import React, { useState } from 'react';
import heroArt from './assets/hero-art.jpg';
import featureTracking from './assets/feature_tracking.jpg';
import featurePerformance from './assets/feature_performance.jpg';
import featureFrameworks from './assets/feature_frameworks.jpg';

function App() {
  const [copied, setCopied] = useState(false);
  const installCommand = 'powershell -c "iex (irm https://raw.githubusercontent.com/PTejasKr/enhanced-winget/master/setup-all.ewin)"';

  const handleCopy = () => {
    navigator.clipboard.writeText(installCommand);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="hermes-web">
      <nav>
        <div style={{ display: 'flex', justifyContent: 'flex-start' }}>
          <a href="#">Docs</a>
        </div>
        
        <div className="nav-center">
          <a href="/"></a>
        </div>

        <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
          <a href="https://github.com/PTejasKr" target="_blank" rel="noreferrer">
            Donate to Developer
          </a>
        </div>
      </nav>

      <header className="hw-vignette">
        <img 
          src={heroArt} 
          alt="" 
          aria-hidden="true" 
          className="hw-hero-art" 
        />
        
        <div className="hw-content">
          <p className="hw-eyebrow">Open Source • MIT License</p>
          
          <h1 className="hw-headline">
            <span>Enhanced</span>
            <span>Winget</span>
            <span>Daemon</span>
          </h1>

          <div className="hw-install-section">
            <p className="hw-eyebrow" style={{ opacity: 0.9 }}>
              Install via terminal
            </p>
            
            <div className="hw-install-box" onClick={handleCopy}>
              <div className="hw-install-code">
                <span className="hw-install-prefix">$&gt; </span>
                powershell -c "iex (irm https://raw.githubusercontent.com/PTejasKr/enhanced-winget/master/setup-all.ewin)"
              </div>
              
              <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center' }}>
                {copied ? (
                  <svg width="24" height="24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" viewBox="0 0 24 24">
                    <polyline points="20 6 9 17 4 12"></polyline>
                  </svg>
                ) : (
                  <svg width="24" height="24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round" viewBox="0 0 24 24">
                    <rect height="13" rx="2" width="13" x="8" y="8"></rect>
                    <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                  </svg>
                )}
              </div>
            </div>
          </div>
        </div>
      </header>

      <section className="hw-features">
        <div className="hw-features-grid">
          
          <article className="hw-feature-card">
            <div className="hw-feature-header">
              <p className="hw-eyebrow" style={{ opacity: 0.8 }}>#1 Autonomous</p>
              <h2>Silent Tracking</h2>
            </div>
            <div className="hw-feature-image">
               <img src={featureTracking} alt="Autonomous tracking" />
            </div>
            <p className="hw-feature-text">
              The daemon tracks package updates in the background. No annoying popups, no manual intervention required. Once installed, it learns and updates automatically.
            </p>
          </article>

          <article className="hw-feature-card">
            <div className="hw-feature-header">
              <p className="hw-eyebrow" style={{ opacity: 0.8 }}>#2 Performance</p>
              <h2>Rust Core</h2>
            </div>
            <div className="hw-feature-image">
               <img src={featurePerformance} alt="Rust core" />
            </div>
            <p className="hw-feature-text">
              Built on a lightning-fast Rust backend. The local system service runs with minimal memory footprint, utilizing Windows WMI to intelligently schedule updates.
            </p>
          </article>

          <article className="hw-feature-card">
            <div className="hw-feature-header">
              <p className="hw-eyebrow" style={{ opacity: 0.8 }}>#3 Complete</p>
              <h2>All Frameworks</h2>
            </div>
            <div className="hw-feature-image">
               <img src={featureFrameworks} alt="All frameworks" />
            </div>
            <p className="hw-feature-text">
              Supports everything. From Winget packages, Scoop binaries, Chocolatey installations, to Python and Rust tooling. Your entire toolchain stays perfectly synced.
            </p>
          </article>

        </div>
      </section>
    </div>
  );
}

export default App;
