# Raw Sources

Drop source documents here for ingestion into the wiki.

## Supported Formats
- Markdown (`.md`) — preferred
- Text (`.txt`)
- Images → place in `assets/` subfolder

## How to Ingest
1. Add your source file to this directory.
2. Tell the LLM agent: **"Ingest `raw/your-filename.md`"**
3. The agent will read it, discuss key takeaways, then update the wiki.

## Tips
- Use [Obsidian Web Clipper](https://obsidian.md/clipper) to convert web articles to markdown.
- One source per file. Name files descriptively (e.g. `attention-is-all-you-need.md`).
- Sources are immutable — the agent reads from here but never modifies these files.
