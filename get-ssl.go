package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
)

const (
	myVersion     = "0.1"
	buildDate     = "20200409"
	sourceProject = "https://github.com/jniltinho/cli-openssl"
)

var (
	serverName string
	urlPort    string
)

func init() {

	flag.Usage = func() {
		fmt.Fprintln(os.Stderr, "Version:", myVersion)
		fmt.Fprintln(os.Stderr, "Built:", buildDate)
		fmt.Fprintln(os.Stderr, "Fonte:", sourceProject)
		flag.PrintDefaults()
	}
	flag.StringVar(&serverName, "s", "", "Host Name => www.domain.com")
	flag.StringVar(&urlPort, "c", "", "URL:PORT =>  www.domain.com:443")

}

func usage() {
	fmt.Printf("Usage : %s -c google.com:443\n", os.Args[0])
	fmt.Printf("Usage : %s -s www.domain.com -c www.domain.com:443\n", os.Args[0])
	os.Exit(0)
}

func main() {

	flag.Usage = usage
	flag.Parse()

	if flag.NFlag() == 0 {
		usage()
		os.Exit(-1)
	}

	if serverName != "" && urlPort != "" {
		showSSLserver(serverName, urlPort)
		os.Exit(0)
	}

	if urlPort != "" {
		showSSL(urlPort)
		os.Exit(0)
	}

}

// Use: out := sh("ls -ltr")
func sh(command string) {
	out, err := exec.Command("/bin/sh", "-c", command).Output()
	if err != nil {
		print(fmt.Sprintf("Failed to execute command: %s", command))
	}
	print(string(out))
}

func showSSLserver(serverName, urlPort string) {

	cmd := fmt.Sprintf("echo|openssl s_client -servername %s -connect %s 2>/dev/null|openssl x509", serverName, urlPort)
	sh(cmd)
}

func showSSL(urlPort string) {

	cmd := fmt.Sprintf("echo|openssl s_client -connect %s 2>/dev/null|openssl x509", urlPort)
	sh(cmd)
}
