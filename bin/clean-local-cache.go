package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
)

///

// each line starts with '/' or is a relative path (against $HOME)
var cleanPatternsListFile = filepath.Join(HOME, "clean.list")

///

const (
	KiB = 1024
	MiB = 1024 * KiB
	GiB = 1024 * MiB
)

var HOME = os.Getenv("HOME")

func humanize(n int64) string {
	if n >= GiB {
		return fmt.Sprintf("%.1f GiB", float64(n)/GiB)
	} else if n >= MiB {
		return fmt.Sprintf("%.1f MiB", float64(n)/MiB)
	} else if n >= KiB {
		return fmt.Sprintf("%.1f KiB", float64(n)/KiB)
	} else {
		return fmt.Sprintf("%.1f B", float64(n))
	}
}

func ask(prefix string, dflt string) bool {
	scanner := bufio.NewScanner(os.Stdin)
	for {
		fmt.Print(prefix)
		scanner.Scan()
		yn := scanner.Text()
		if yn == "y" || yn == "Y" || (yn == "" && dflt == "y") {
			return true
		} else if yn == "n" || yn == "N" || (yn == "" && dflt == "n") {
			return false
		}
	}
}

///

func getPatterns(filename string) []string {
	contents, err := os.ReadFile(filename)
	if err != nil {
		log.Fatal(err)
	}
	return strings.Split(string(contents), "\n")
}

func getPaths(patterns []string) map[string]int64 {
	paths := map[string]int64{}

	for _, p := range patterns {
		if len(p) == 0 {
			continue
		}
		if p[0] != '/' {
			p = filepath.Join(HOME, p)
		}

		matches, err := filepath.Glob(p)
		if err != nil {
			log.Fatalf("glob path %v failed: %v", p, err)
		}
		for _, m := range matches {
			size, err := getSize(m)
			if err != nil {
				continue
			}
			if size > 0 {
				paths[m] = size
				//log.Printf("path: %v, size: %v", m, size)
			}
		}
	}

	return paths
}

func getSize(path string) (int64, error) {
	var size int64
	err := filepath.Walk(
		path,
		func(_ string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if !info.IsDir() {
				size += info.Size()
			}
			return err
		})
	return size, err
}

func main() {
	patterns := getPatterns(cleanPatternsListFile)
	//log.Print(patterns)
	paths := getPaths(patterns)

	if len(paths) == 0 {
		fmt.Println("Nothing to remove.")
		return
	}

	fmt.Println("Do you really want to delete the following files:\n")
	var total int64
	for p, size := range paths {
		fmt.Printf("%12s  %v\n", humanize(size), p)
		total += size
	}
	fmt.Println("         ---  -----")
	fmt.Printf("%12s  total\n\n", humanize(total))
	fmt.Println("?")

	if !ask("[Y/n] -> ", "y") {
		return
	}

	fmt.Println("deleting files...")
	for p := range paths {
		err := os.RemoveAll(p)
		if err != nil {
			log.Printf("remove %v failed: %v", p, err)
		}
	}
}
