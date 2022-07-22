package phantomjs

import (
	"fmt"
	"net/http"
	"strings"
	"time"

	p "github.com/benbjohnson/phantomjs"
)

func VerifyPageContent(uri string) (bool, error) {
	// Create a web page.
	// IMPORTANT: Always make sure you close your pages!
	err := p.DefaultProcess.Open()
	if err != nil {
		return false, fmt.Errorf("failed to create page: %s", err)
	}
	defer p.DefaultProcess.Close()

	page, err := p.CreateWebPage()
	if err != nil {
		return false, fmt.Errorf("failed to create page: %s", err)
	}
	defer page.Close()

	settings := p.WebPageSettings{
		JavascriptEnabled:             true,
		LoadImages:                    false,
		LocalToRemoteURLAccessEnabled: true,
		XSSAuditingEnabled:            true,
		WebSecurityEnabled:            true,
		ResourceTimeout:               10 * time.Second,
	}
	if err := page.SetSettings(settings); err != nil {
		return false, fmt.Errorf("failed to set settings: %s", err)
	}

	// Open a URL.
	if err := page.Open(uri); err != nil {
		return false, fmt.Errorf("failed to open page: %s", err)
	}

	if err := page.SetCustomHeaders(http.Header{
		"Accept": []string{"application/json"},
	}); err != nil {
		return false, fmt.Errorf("failed to set headers: %s", err)
	}

	content, err := page.PlainText()
	if err != nil {
		return false, fmt.Errorf("failed to render page: %s", err)
	}

	return !strings.Contains(content, "Sold out online"), nil
}
