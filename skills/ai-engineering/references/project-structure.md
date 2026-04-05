# AI/LLM Project Structure

## Directory Layout
```
src/
  agents/                   # Agent definitions — persona, tools, orchestration
    __init__.py
    researcher.py           # Research agent definition
    writer.py               # Writing agent definition
    orchestrator.py         # Multi-agent coordination
  chains/                   # LLM chain/pipeline definitions
    __init__.py
    summarize.py            # Summarization pipeline
    classify.py             # Classification pipeline
    extract.py              # Extraction pipeline
  prompts/                  # Prompt templates — never inline in code
    system/                 # System prompts
      researcher.md
      writer.md
    templates/              # Reusable prompt templates
      summarize.md
      classify.md
  tools/                    # Tool definitions for agents
    __init__.py
    search.py               # Search tool
    database.py             # Database query tool
    api.py                  # External API tool
  embeddings/               # Embedding generation and management
    __init__.py
    generator.py            # Embed text using configured model
    store.py                # Vector store operations (upsert, search)
  retrieval/                # RAG retrieval logic
    __init__.py
    retriever.py            # Query embedding + similarity search
    chunker.py              # Document chunking strategies
    reranker.py             # Result reranking
  config.py                 # Model configs, provider settings from env
  client.py                 # LLM client wrapper (provider abstraction)
tests/
  conftest.py               # Shared fixtures, mock LLM client
  test_agents/
  test_chains/
  test_tools/
  fixtures/                 # Mock LLM responses, test documents
    responses/              # Canned LLM responses for deterministic tests
    documents/              # Test documents for RAG testing
```

## Rules

### Prompts
- Prompts live in `prompts/` as separate files — never inline strings in Python
- System prompts are markdown files loaded at agent init
- Template variables use clear names: `{context}`, `{user_query}`, `{documents}`
- Version prompts with the repo — prompt changes are code changes

### Testing
- Mock LLM responses in `fixtures/responses/` — tests must be deterministic
- Test tool functions independently with real logic, mocked external calls
- Test chains with canned responses to verify orchestration logic
- Never call real LLM APIs in unit tests — use fixtures or mock client

### Configuration
- All API keys and model names from environment variables via `config.py`
- No hardcoded model names — configure per environment
- Rate limits and token budgets in config, not scattered through code
- Provider abstraction in `client.py` so model swaps don't touch business logic

### Separation of Concerns
- **Agents** define persona and tool bindings — they don't implement tools
- **Chains** define pipeline steps — they don't know about HTTP or storage
- **Tools** are pure functions with typed inputs/outputs — agents call them
- **Retrieval** is separate from generation — retriever returns docs, chain uses them
- **Embeddings** handle vector operations only — no LLM generation logic

### Cost and Observability
- Log token usage (input + output) on every LLM call
- Route by complexity: cheap model for simple tasks, expensive for hard ones
- Set max_tokens appropriate to task — don't use model max as default
- Cache embedding results when documents don't change
