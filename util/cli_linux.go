package util

import (
	"fmt"
	"log"
	"os"
	"os/exec"
)

// Use: out := sh("ls -ltr")
func sh(command string) {
	out, err := exec.Command("/bin/sh", "-c", command).Output()
	if err != nil {
		print(fmt.Sprintf("Failed to execute command: %s", command))
	}
	print(string(out))
}

func run(command string) {
	cmd := exec.Command("/bin/sh", "-c", command)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	// cmd.Stdin = os.Stdin
	if err := cmd.Run(); err != nil {
		log.Fatal(err)
	}
}

func createFile(command, filename string) {
	cmd := exec.Command("/bin/sh", "-c", command)
	// open the out file for writing
	outfile, err := os.Create(filename)
	if err != nil {
		panic(err)
	}
	defer outfile.Close()
	cmd.Stdout = outfile

	err = cmd.Start()
	if err != nil {
		panic(err)
	}
	cmd.Wait()
}
