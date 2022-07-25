package browser

import (
	"time"

	"github.com/go-rod/rod"
)

const (
	pageTimeout time.Duration = 2 * time.Minute
)

func VerifyPageContent(uri string) (bool, error) {
	browser := rod.New().MustConnect().Timeout(pageTimeout)
	defer browser.MustClose()

	page := browser.MustPage(uri)

	// Make sure we don't land on sold out page
	if _, err := page.Search("Looks like we’re all out"); err == nil {
		// text found in page, so product is out of stock
		return false, nil
	}

	// Make sure product doesn't mention sold out online
	if _, err := page.Search("Sold out online"); err == nil {
		// text found in page, so product is out of stock
		return false, nil
	}

	// text found in page, product is in stock
	return true, nil
}
