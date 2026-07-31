import os

def get_reddit_sentiment(app_name: str, version: str) -> str:
    return f"{app_name} {version} is running smoothly without major crashes. A few minor UI bugs were mentioned but no BSODs."

def get_news_sentiment(app_name: str, version: str) -> str:
    return f"Latest update for {app_name} (version {version}) resolves several critical CVEs and improves performance by 15%."

def aggregate_data(app_name: str, versions: list) -> str:
    aggregated_text = ""
    for v in versions:
        version_str = v.get("version", "")
        aggregated_text += f"\n--- Data for Version {version_str} ---\n"
        aggregated_text += get_reddit_sentiment(app_name, version_str) + "\n"
        aggregated_text += get_news_sentiment(app_name, version_str) + "\n"
    return aggregated_text
