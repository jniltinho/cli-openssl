/*
Copyright © 2020 NAME HERE <EMAIL ADDRESS>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package cmd

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"

	"github.com/spf13/cobra"
)

const (
	myVersion     = "0.1"
	buildDate     = "20200410"
	sourceProject = "https://github.com/jniltinho/cli-openssl"
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "get-ssl -c www.domain.com:443",
	Short: "Get keys SSL .crt HTTPS Web Server",

	// Uncomment the following line if your bare application
	// has an action associated with it:
	Run: func(cmd *cobra.Command, args []string) {
		connect, _ := cmd.Flags().GetString("connect")
		serverName, _ := cmd.Flags().GetString("server-name")

		if serverName != "" && connect != "" {
			getFullSSL(serverName, connect)
			os.Exit(0)
		}

		if connect != "" {
			getSSL(connect)
			os.Exit(0)
		}

	},
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func init() {

	rootCmd.AddCommand(versionCmd)
	rootCmd.PersistentFlags().StringP("connect", "c", "google.com:443", "Hostname and Port www.domain.com:443")
	rootCmd.PersistentFlags().StringP("server-name", "s", "", "Hostname => www.domain.com")
	//rootCmd.MarkPersistentFlagRequired("connect")

}

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Print the version number of get-ssl",
	Run: func(cmd *cobra.Command, args []string) {
		println("Version:", myVersion)
		println("Built:", buildDate)
		println("Source:", sourceProject)
	},
}

func getFullSSL(hostName, hostNamePort string) {

	cmd := fmt.Sprintf("echo|openssl s_client -servername %s -connect %s 2>/dev/null|openssl x509", hostName, hostNamePort)
	filename := strings.Split(hostNamePort, ".")[0] + ".crt"
	run(cmd, filename)
}

func getSSL(hostNamePort string) {

	cmd := fmt.Sprintf("echo|openssl s_client -connect %s 2>/dev/null|openssl x509", hostNamePort)
	filename := strings.Split(hostNamePort, ".")[0] + ".crt"
	run(cmd, filename)

}

func run(command, filename string) {

	stdout, err := exec.Command("/bin/sh", "-c", command).CombinedOutput()
	if err != nil {
		log.Fatal(string(stdout), err)
	}
	print(string(stdout))

	outfile, err := os.Create(filename)
	if err != nil {
		log.Fatal(err)
	}

	if _, err := outfile.Write(stdout); err != nil {
		log.Fatal(err)
	}

	defer outfile.Close()
}
