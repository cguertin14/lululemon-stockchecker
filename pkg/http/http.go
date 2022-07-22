package http

import (
	"fmt"
	"net/http"
	"strings"
)

func VerifyPageStatusCode(uri string) (bool, error) {
	request, err := http.NewRequest(http.MethodGet, uri, nil)
	if err != nil {
		return false, fmt.Errorf("failed to construct new http request: %s", err)
	}

	// Add header to request, otherwise it won't work
	request.Header = http.Header{"Accept": []string{"application/json"}}
	client := &http.Client{}
	res, err := client.Do(request)
	if err != nil {
		if !strings.Contains(err.Error(), "stopped after") {
			return false, fmt.Errorf("failed to perform GET request: %s", err)
		}
	}
	defer res.Body.Close()

	// Make sure statusCode is 200
	return res.StatusCode == http.StatusOK, nil
}
