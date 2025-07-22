package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

const dbDirStage = "../live/stage/data-stores/mysql"
const appDirStage = "../live/stage/services/webserver-cluster"

func TestHelloWorldWithStages(t *testing.T) {
	t.Parallel()

	stage := test_structure.RunTestStage

	defer stage(t, "teardown_db", func() { teardownDb(t, dbDirStage) })
	stage(t, "deploy_db", func() { deployDb(t, dbDirStage) })

	defer stage(t, "teardown_app", func() { teardownApp(t, appDirStage) })
	stage(t, "deploy_app", func() { deployApp(t, dbDirStage, appDirStage) })

	stage(t, "validate_app", func() { validateApp(t, appDirStage) })

}

func deployDb(t *testing.T, dbDir string) {
	dbOpts := createDbOpts(t, dbDir)
	dbOpts.MigrateState = true

	test_structure.SaveTerraformOptions(t, dbDir, dbOpts)
	terraform.InitAndApply(t, dbOpts)
}

func teardownDb(t *testing.T, dbDir string) {
	dbOpts := test_structure.LoadTerraformOptions(t, dbDir)
	defer terraform.Destroy(t, dbOpts)
}

func deployApp(t *testing.T, dbDir string, helloAppDir string) {
	dbOpts := test_structure.LoadTerraformOptions(t, dbDir)
	helloOpts := createHelloOpts(dbOpts, helloAppDir)
	helloOpts.MigrateState = true

	test_structure.SaveTerraformOptions(t, helloAppDir, helloOpts)
	terraform.InitAndApply(t, helloOpts)
}

func teardownApp(t *testing.T, helloAppDir string) {
	helloOpts := test_structure.LoadTerraformOptions(t, helloAppDir)
	defer terraform.Destroy(t, helloOpts)
}

func validateApp(t *testing.T, helloAppDir string) {
	helloOpts := test_structure.LoadTerraformOptions(t, helloAppDir)
	validateHelloApp(t, helloOpts)
}

func TestHelloWorldAppStage(t *testing.T) {
	t.Parallel()

	dbOpts := createDbOpts(t, dbDirStage)
	dbOpts.MigrateState = true
	defer terraform.Destroy(t, dbOpts)
	terraform.InitAndApply(t, dbOpts)

	helloopts := createHelloOpts(dbOpts, appDirStage)
	helloopts.MigrateState = true
	defer terraform.Destroy(t, helloopts)
	terraform.InitAndApply(t, helloopts)

	validateHelloApp(t, helloopts)
}

func createDbOpts(t *testing.T, terraformDir string) *terraform.Options {
	UniqueId := random.UniqueId()

	bucketForTesting := "terrr-state-file"
	bucketRegionForTesting := "us-east-1"
	dbStateKey := fmt.Sprintf("%s/%s/terraform.tfstate", t.Name(), UniqueId)

	return &terraform.Options{
		TerraformDir: terraformDir,

		Vars: map[string]any{
			"db_name":     fmt.Sprintf("test%s", UniqueId),
			"db_username": "admin",
			"db_password": "password",
		},

		BackendConfig: map[string]any{
			"bucket":  bucketForTesting,
			"region":  bucketRegionForTesting,
			"key":     dbStateKey,
			"encrypt": true,
		},
	}
}

func createHelloOpts(
	dbOpts *terraform.Options,
	terraformDir string) *terraform.Options {

	return &terraform.Options{
		TerraformDir: terraformDir,

		Vars: map[string]any{
			"db_remote_state_bucket": dbOpts.BackendConfig["bucket"],
			"db_remote_state_key":    dbOpts.BackendConfig["key"],
			"environment":            dbOpts.Vars["db_name"],
		},

		MaxRetries:         10,
		TimeBetweenRetries: 5 * time.Second,
		RetryableTerraformErrors: map[string]string{
			"RequestError: send request failed": "Throttling issue?",
		},
	}
}

func validateHelloApp(t *testing.T, helloopts *terraform.Options) {
	albDnsName := terraform.OutputRequired(t, helloopts, "alb_dns_name")
	appPath := terraform.OutputRequired(t, helloopts, "app_path")
	url := fmt.Sprintf("http://%s%s", albDnsName, appPath)
	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			return status == 200 &&
				strings.Contains(body, "Test Cluster")
		},
	)
}
