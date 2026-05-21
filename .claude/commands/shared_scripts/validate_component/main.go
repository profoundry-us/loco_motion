// validate_component checks that all required files exist for a LocoMotion
// component and that it is registered in lib/loco_motion/helpers.rb.
//
// Usage:
//
//	go run main.go <component_name> <component_group>
//
// Examples:
//
//	go run main.go button actions
//	go run main.go text_input data_input
//	go run main.go card data_display
package main

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

type CheckResult struct {
	Path   string
	Exists bool
	Note   string
}

func pluralize(name string) string {
	// Simple pluralization rules for common component naming patterns
	if strings.HasSuffix(name, "y") {
		return name[:len(name)-1] + "ies"
	}
	if strings.HasSuffix(name, "s") || strings.HasSuffix(name, "x") ||
		strings.HasSuffix(name, "z") || strings.HasSuffix(name, "ch") ||
		strings.HasSuffix(name, "sh") {
		return name + "es"
	}
	return name + "s"
}

func toPascalCase(snake string) string {
	parts := strings.Split(snake, "_")
	result := ""
	for _, part := range parts {
		if len(part) > 0 {
			result += strings.ToUpper(part[:1]) + part[1:]
		}
	}
	return result
}

func fileExists(path string) bool {
	_, err := os.Stat(path)
	return !os.IsNotExist(err)
}

func checkHelperRegistration(root, componentClass string) (bool, error) {
	helpersPath := filepath.Join(root, "lib", "loco_motion", "helpers.rb")

	f, err := os.Open(helpersPath)
	if err != nil {
		return false, fmt.Errorf("could not open helpers.rb: %w", err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		if strings.Contains(scanner.Text(), componentClass) {
			return true, nil
		}
	}

	return false, scanner.Err()
}

func main() {
	if len(os.Args) < 3 {
		fmt.Fprintln(os.Stderr, "Usage: validate_component <component_name> <component_group>")
		fmt.Fprintln(os.Stderr, "")
		fmt.Fprintln(os.Stderr, "Examples:")
		fmt.Fprintln(os.Stderr, "  go run main.go button actions")
		fmt.Fprintln(os.Stderr, "  go run main.go text_input data_input")
		os.Exit(1)
	}

	name := os.Args[1]
	group := os.Args[2]

	// Find project root by looking for the justfile
	root := "."
	for i := 0; i < 5; i++ {
		if fileExists(filepath.Join(root, "justfile")) {
			break
		}
		root = filepath.Join("..", root)
	}

	moduleGroup := toPascalCase(group)
	className := toPascalCase(name)
	pluralName := pluralize(name)
	componentClass := fmt.Sprintf("Daisy::%s::%sComponent", moduleGroup, className)

	fmt.Printf("Validating component: %s (%s)\n", name, group)
	fmt.Printf("  Class: %s\n\n", componentClass)

	checks := []CheckResult{
		{
			Path: filepath.Join(root, "app", "components", "daisy", group,
				name+"_component.rb"),
		},
		{
			Path: filepath.Join(root, "app", "components", "daisy", group,
				name+"_component.html.haml"),
		},
		{
			Path: filepath.Join(root, "spec", "components", "daisy", group,
				name+"_component_spec.rb"),
		},
		{
			Path: filepath.Join(root, "docs", "demo", "app", "views",
				"examples", "daisy", group, pluralName+".html.haml"),
		},
	}

	allPass := true

	for _, check := range checks {
		check.Exists = fileExists(check.Path)
		status := "✓"
		if !check.Exists {
			status = "✗"
			allPass = false
		}
		fmt.Printf("  %s %s\n", status, check.Path)
	}

	// Check helpers.rb registration
	registered, err := checkHelperRegistration(root, componentClass)
	if err != nil {
		fmt.Fprintf(os.Stderr, "\nWarning: could not check helpers.rb: %v\n", err)
	} else {
		status := "✓"
		if !registered {
			status = "✗"
			allPass = false
		}
		fmt.Printf("  %s Registered in lib/loco_motion/helpers.rb\n", status)
	}

	fmt.Println()
	if allPass {
		fmt.Println("All checks passed!")
	} else {
		fmt.Println("Some checks failed — run /new-component to create missing files.")
		os.Exit(1)
	}
}
