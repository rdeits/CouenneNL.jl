using BinDeps
using Compat

const basedir = dirname(@__FILE__)
const prefix = joinpath(basedir, "usr")
const base_url = "https://ampl.com/dl/open/couenne"
const binary_name = Compat.Sys.iswindows() ? "couenne.exe" : "couenne"

const file_base = if Compat.Sys.iswindows()
    if Sys.ARCH == :x86_64
        "couenne-win64"
    else
        "couenne-win32"
    end
elseif Compat.Sys.islinux()
    if Sys.ARCH == :x86_64
        "couenne-linux64"
    else
        "couenne-linux32"
    end
elseif Compat.Sys.isapple()
    "couenne-osx"
else
    error("Unsupported operating system. Only Windows, Linux, and OSX are supported.")
end

function install_binaries(file_base, file_ext)
    filename = "$(file_base).$(file_ext)"
    url = "$(base_url)/$(filename)"
    binary_path = joinpath(basedir, "downloads", file_base)

    @static if Compat.Sys.iswindows()
        install_step = () -> begin
            for file in readdir(binary_path)
                cp(joinpath(binary_path, file),
                   joinpath(prefix, "bin", file);
                   remove_destination=true)
            end
        end
    else
        install_step = () -> begin
            for file in readdir(binary_path)
                symlink(joinpath(binary_path, file),
                        joinpath(prefix, "bin", file))
            end
        end
    end

    function test_step()
        run(`$(joinpath(prefix, "bin", binary_name)) --version`)
    end


    (@build_steps begin
        FileRule(joinpath(prefix, "bin", binary_name),
            (@build_steps begin
                FileDownloader(url, joinpath(basedir, "downloads", filename))
                FileUnpacker(joinpath(basedir, "downloads", filename),
                             joinpath(basedir, "downloads", file_base),
                             binary_name)
                CreateDirectory(joinpath(prefix, "bin"))
                install_step
                test_step
            end))
    end)
end

process = install_binaries(file_base, "zip")
run(process)

open(joinpath(dirname(@__FILE__), "deps.jl"), "w") do f
    write(f, """
const couenne_executable = "$(escape_string(joinpath(prefix, "bin", binary_name)))"
""")
end
