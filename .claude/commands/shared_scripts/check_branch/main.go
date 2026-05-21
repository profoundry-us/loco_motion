// check_branch validates that the current git branch name follows the
// LocoMotion naming convention: {type}-{issue_number}-{brief-description}
//
// Usage:
//
//	go run main.go
//	go run main.go feat-123-add-button-component
package main

import (
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"strings"
)

var (
	validTypes  = []string{"feat", "bug", "fix", "task", "chore", "docs", "refactor", "claude"}
	branchRegex = regexp.MustCompile(`^([a-z]+)-(\d+)-([a-z0-9]+(?:-[a-z0-9]+)*)$`)
)

func main() {
	branch := ""

	if len(os.Args) > 1 {
		branch = os.Args[1]
	} else {
		out, err := exec.Command("git", "branch", "--show-current").Output()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: could not get current branch: %v\n", err)
			os.Exit(1)
		}
		branch = strings.TrimSpace(string(out))
	}

	if branch == "" {
		fmt.Fprintln(os.Stderr, "Error: branch name is empty")
		os.Exit(1)
	}

	if branch == "main" {
		fmt.Fprintln(os.Stderr, "Error: you are on the main branch — switch to a feature branch first")
		os.Exit(2)
	}

	matches := branchRegex.FindStringSubmatch(branch)
	if matches == nil {
		fmt.Fprintf(os.Stderr, "Error: branch '%s' does not match convention {type}-{issue_number}-{description}\n", branch)
		fmt.Fprintf(os.Stderr, "  Expected: feat-123-add-button-component\n")
		fmt.Fprintf(os.Stderr, "  Valid types: %s\n", strings.Join(validTypes, ", "))
		os.Exit(3)
	}

	branchType := matches[1]
	issueNum := matches[2]
	desc := matches[3]

	validType := false
	for _, t := range validTypes {
		if t == branchType {
			validType = true
			break
		}
	}

	if !validType {
		fmt.Fprintf(os.Stderr, "Error: branch type '%s' is not valid\n", branchType)
		fmt.Fprintf(os.Stderr, "  Valid types: %s\n", strings.Join(validTypes, ", "))
		os.Exit(4)
	}

	fmt.Printf("Branch: %s\n", branch)
	fmt.Printf("  Type:        %s\n", branchType)
	fmt.Printf("  Issue:       #%s\n", issueNum)
	fmt.Printf("  Description: %s\n", desc)
	fmt.Println("OK: Branch name follows convention")
}
