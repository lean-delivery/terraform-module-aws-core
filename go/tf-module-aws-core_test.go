package test

import (
	"testing"
	// "fmt"
	"time"
    "math/rand"
	"github.com/gruntwork-io/terratest/modules/terraform"
	// "github.com/stretchr/testify/assert"
)

var terraformDirectory = "../examples/"
var aws_region         = "us-east-1"
var project            = "Project"
var environment        = "dev"
var availability_zones = []string{aws_region + "a", aws_region + "b", aws_region + "c"}
var vpc_cidr           = "192.168.0.0/16"
var private_subnets    = []string{"192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"}
var public_subnets     = []string{"192.168.3.0/24", "192.168.4.0/24", "192.168.5.0/24"}
var enable_nat_gateway = true

func Test_Standart(t *testing.T) {
	rand.Seed(time.Now().UnixNano())

	terraformOptions := &terraform.Options{
		TerraformDir: terraformDirectory,
		Vars: map[string]interface{}{
			"region":             aws_region,
			"project":            project + "_" + randSeq(10),
  			"environment":        environment,
  			"availability_zones": availability_zones,
  			"vpc_cidr":           vpc_cidr,
  			"private_subnets":    private_subnets,
  			"public_subnets":     public_subnets,
  			"enable_nat_gateway": enable_nat_gateway,
		},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.Init(t, terraformOptions)
	terraform.Apply(t, terraformOptions)
}

var instance_type = "t2.large"

func Test_Large_instances(t *testing.T) {
	rand.Seed(time.Now().UnixNano())

	terraformOptions := &terraform.Options{
		TerraformDir: terraformDirectory,
		Vars: map[string]interface{}{
			"region":             aws_region,
			"project":            project + "_" + randSeq(10),
  			"environment":        environment,
  			"availability_zones": availability_zones,
  			"vpc_cidr":           vpc_cidr,
  			"private_subnets":    private_subnets,
  			"public_subnets":     public_subnets,
  			"enable_nat_gateway": enable_nat_gateway,
  			"instance_type":      instance_type,
		},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.Init(t, terraformOptions)
	terraform.Apply(t, terraformOptions)
}

func randSeq(n int) string {
	letters := []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    b := make([]rune, n)
    for i := range b {
        b[i] = letters[rand.Intn(len(letters))]
    }
    return string(b)
}
