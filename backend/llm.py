import json

SYSTEM_PROMPT = """
You are the Ew Cloud Brain, an AI agent responsible for evaluating software update stability across multiple package manager repositories (Winget, Scoop, Chocolatey).

You will receive an application name, a list of available candidate versions from different repositories, and a block of text containing scraped community sentiment (Reddit) and tech news reports.

Your goal is to evaluate the provided text and output a strictly formatted JSON object determining the safest and best version to install.
Assign a "Sentiment" score from 0 to 100 based on the following:
- 90-100: No major issues, resolves critical bugs/CVEs.
- 70-89: Minor bugs exist, or it is a major feature release requiring caution.
- 0-69: Critical crashes, BSODs, or memory leaks reported.

OUTPUT FORMAT (Respond ONLY with valid JSON):
{
  "App": "<App Name>",
  "Selected_Repo": "<winget | scoop | chocolatey>",
  "Version": "<Selected Version string>",
  "Decision": "<Proceed | Quarantine>",
  "Sentiment": <integer between 0 and 100>,
  "Suspend_Days": <integer, usually 0 unless Quarantined, then e.g. 7>
}
"""

def generate_llm_decision(app_name: str, versions: list, aggregated_data: str) -> dict:
    """
    Stubs the LLM call using DeepSeek/Claude APIs.
    """
    # In a real environment:
    # client = anthropic.Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))
    # response = client.messages.create(
    #     model="claude-3-5-sonnet-20240620",
    #     system=SYSTEM_PROMPT,
    #     messages=[{"role": "user", "content": f"App: {app_name}\nVersions: {json.dumps(versions)}\nData:\n{aggregated_data}"}]
    # )
    # return json.loads(response.content[0].text)
    
    # Mock fallback simulating a successful LLM parse based on the prompt
    best_candidate = versions[0] if versions else {"repo": "winget", "version": "unknown"}
    return {
        "App": app_name,
        "Selected_Repo": best_candidate.get("repo", "winget"),
        "Version": best_candidate.get("version", "unknown"),
        "Decision": "Proceed",
        "Sentiment": 95, 
        "Suspend_Days": 0
    }
