local mason_registry = require "mason-registry"
local codelldb_path = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/adapter/codelldb"

-- Get current filetype
local filetype = vim.bo.filetype

-- Function to get last modified time
local function get_mod_time(file)
  local handle = io.popen("stat -c %Y " .. file .. " 2>/dev/null")
  if not handle then
    print("Warning: Failed to check modification time for " .. file)
    return 0
  end
  local mod_time = handle:read("*a"):gsub("\n", "")
  handle:close()
  return tonumber(mod_time) or 0
end

-- Function to compile C and C++
local function compile_c_cpp(source, output, lang)
  local compile_cmd = lang == "c" and string.format("gcc -g %s -o %s", source, output)
    or string.format("g++ -g %s -o %s", source, output)
  print("Compiling:", compile_cmd)
  os.execute(compile_cmd)
end

-- Function to compile Rust
local function compile_rust()
  print "Building Rust project..."
  os.execute "cargo build"
  return vim.fn.getcwd() .. "/target/debug/main"
end

-- Function to compile Zig
local function compile_zig()
  print "Building Zig project..."
  os.execute "zig build"
  return vim.fn.getcwd() .. "/zig-out/bin/main"
end

-- Function to determine program to run
local function get_program(lang)
  local input_path = vim.fn.input("Path to " .. lang .. " file or executable: ", vim.fn.getcwd() .. "/", "file")

  -- If "main" is entered, find the correct main file
  if input_path == "main" then
    local ext = lang == "c" and "c" or lang == "cpp" and "cpp" or lang == "rust" and "rs" or "zig"
    local handle = io.popen("find . -name 'main." .. ext .. "' | head -n 1")

    if not handle then
      error("Failed to search for main." .. ext .. " in project!")
    end

    input_path = handle:read "*a"
    handle:close()

    input_path = input_path and input_path:gsub("\n", "") or ""

    if input_path == "" then
      error("main." .. ext .. " not found in project!")
    end
  end

  -- If input is a source file
  if
    input_path:match(
      "%." .. (lang == "cpp" and "cpp" or lang == "c" and "c" or lang == "rust" and "rs" or "zig") .. "$"
    )
  then
    local exe_path = lang == "c" and input_path:gsub("%.c$", ".exe")
      or lang == "cpp" and input_path:gsub("%.cpp$", ".exe")
      or lang == "rust" and compile_rust()
      or compile_zig()

    -- Check timestamps
    local src_time = get_mod_time(input_path)
    local exe_time = get_mod_time(exe_path)

    if exe_time < src_time then
      if lang == "c" or lang == "cpp" then
        compile_c_cpp(input_path, exe_path, lang)
      elseif lang == "rust" then
        compile_rust()
      else
        compile_zig()
      end
    else
      print("Using existing executable:", exe_path)
    end

    return exe_path
  end

  -- If input is an executable
  if input_path:match "%.exe$" or input_path:match "target/debug/" or input_path:match "zig%-out/bin/" then
    local src_path = input_path
      :gsub("%.exe$", ".c")
      :gsub("%.exe$", ".cpp")
      :gsub("target/debug/", "src/main.rs")
      :gsub("zig%-out/bin/", "src/main.zig")

    if get_mod_time(src_path) > 0 then
      local exe_time = get_mod_time(input_path)
      local src_time = get_mod_time(src_path)

      if exe_time < src_time then
        error "Executable is outdated. Please rebuild."
      end
    else
      print("Warning: No matching source file found for", input_path)
    end

    return input_path
  end

  error "Invalid input: Provide a source file or a valid executable."
end

-- Define configurations per language
local configs = {
  c = {
    {
      name = "Launch C",
      type = "c",
      request = "launch",
      program = function()
        return get_program "c"
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
      args = {},
    },
  },
  cpp = {
    {
      name = "Launch C++",
      type = "cpp",
      request = "launch",
      program = function()
        return get_program "cpp"
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
      args = {},
    },
  },
  rust = {
    {
      name = "Launch Rust",
      type = "c",
      request = "launch",
      program = function()
        return get_program "rust"
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
      args = {},
      env = { "RUST_BACKTRACE=1" },
    },
  },
  zig = {
    {
      name = "Launch Zig",
      type = "c",
      request = "launch",
      program = function()
        return get_program "zig"
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
      args = {},
    },
  },
}

-- Return only the relevant debugger for the current filetype
return {
  adapter = {
    type = "server",
    port = "${port}",
    executable = {
      command = codelldb_path,
      args = { "--port", "${port}" },
    },
  },
  configurations = configs[filetype] or {},
}
