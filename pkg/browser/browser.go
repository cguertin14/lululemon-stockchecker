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
	_, err := page.Search("Sold out online")
	if err != nil {
		// text not found in page, so product is in stock
		return true, nil
	}

	// text found in page, product is out-of-stock
	return false, nil
}
