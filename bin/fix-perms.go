//
// Fix permissions for regular files.
//
// Usage:
//
//   go run fix-perms.go            -- fix permissions for files under current dir
//   go run fix-perms.go dir1 ...   -- fix permissions for files under dirs dir1, ...
//

package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

type Filetype int

const (
	// TODO: apply more intellectual settings, like go-w / go-wx
	MODE_FILE os.FileMode = 0644
	MODE_DIR  os.FileMode = 0755
)

var EXCLUDE = []string{
	".asciidoc", ".adoc", ".txt", ".md", ".rst", ".doc", ".odt",
	".html", ".css",
	".gif", ".jpg", ".png",
	".m3u8", ".mp3", ".ogg",
	".avi", ".mp4", ".webm",
	".djvu", ".epub", ".fb2", ".pdf",
	".zip", ".gz", ".bz2", ".bzip2", ".tgz", ".tbz2", ".tzst",
	".cpp", ".go", ".java", ".c",
}

var NO_ACT = true

func exclude_file(fname string) bool {
	fname_low := strings.ToLower(fname)
	for _, suff := range EXCLUDE {
		if strings.HasSuffix(fname_low, suff) {
			return true
		}
	}
	return false
}

func fix_mode(file string, old_mode, mode os.FileMode) {
	if mode != MODE_DIR && mode != MODE_FILE {
		panic("invalid permission mode!!!")
	}
	fmt.Printf("change perms %o -> %o for %s\n", old_mode, mode, file)
	if !NO_ACT {
		err := os.Chmod(file, mode)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
	}
}

func chmod_files_in_dir(dir string, dirs *[]string, files_changed, dirs_changed *uint) {
	file, err := os.Open(dir)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	files, err := file.Readdir(0)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	for _, f := range files {
		full_file_path := filepath.Join(dir, "/", f.Name())
		mode := f.Mode()
		if mode.IsDir() {
			if mode.Perm() != MODE_DIR {
				fix_mode(full_file_path, mode.Perm(), MODE_DIR)
				*dirs_changed++
			}
			*dirs = append(*dirs, full_file_path)
		} else if mode.IsRegular() && mode.Perm() != MODE_FILE && exclude_file(f.Name()) {
			fix_mode(full_file_path, mode.Perm(), MODE_FILE)
			*files_changed++
		} else {
			//fmt.Printf("Nothing to change for file %s\n", f.Name())
		}
	}
}

func main() {
	// TODO: add option parsing
	args_first_file_index := 1
	if len(os.Args) > 1 && os.Args[1] == "-y" {
		NO_ACT = false
		args_first_file_index = 2
	}

	dirs := []string{"."}
	if len(os.Args) > 1 {
		dirs = os.Args[args_first_file_index:]
	}
	fmt.Printf("scanning following directories: %v\n", dirs)
	if NO_ACT {
		fmt.Println("NO ACTION mode in on")
	}

	var files_changed, dirs_changed uint

	for len(dirs) > 0 {
		dir := dirs[0]
		dirs = dirs[1:]
		chmod_files_in_dir(dir, &dirs, &files_changed, &dirs_changed)
	}

	fmt.Printf("permissions fixed for %d files and %d dirs\n", files_changed, dirs_changed)
}
