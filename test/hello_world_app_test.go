package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestHelloWorldAppExample(t *testing.T) {
	t.Parallel()

	opts := &terraform.Options{
		TerraformDir: "../examples/hello-world-app",

		Vars: map[string]interface{}{
			"mysql_config": map[string]interface{}{
				"address": "mockValuesforTest",
				"port":    3306,
			},
			"environment": fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId())),
		},
	}
	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	albDnsName := terraform.OutputRequired(t, opts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)
	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			return status == 200 && strings.Contains(body, "Hello, World!")
		},
	)
}
