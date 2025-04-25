local M = {}

M.setup = function ()
  return {
    -- provider = 'openai',
    -- openai = {
    --   endpoint = 'https://api.openai.com/v1',
    --   model = 'gpt-4o', -- your desired model (or use gpt-4o, etc.)
    --   timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
    --   temperature = 0,
    --   max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
    --   --reasoning_effort = 'medium', -- low|medium|high, only used for reasoning models
    -- },
    provider = 'claude',
    claude = {
      endpoint = 'https://api.anthropic.com',
      -- model = 'claude-3-5-sonnet-20241022',
      model = 'claude-3-7-sonnet-20250219',
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      max_tokens = 4096,
      disable_tools = { 'python' }, -- disable tools!
    },
    -- behaviour = {
    --   enable_claude_text_editor_tool_mode = true,
    -- }
    -- windows = {
    --   position = 'left',
    -- },
  }
end

return M
