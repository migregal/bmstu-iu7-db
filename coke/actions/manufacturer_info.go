package actions

import (
	"coke/models"
	"encoding/json"
	"github.com/gobuffalo/buffalo"
	"github.com/pkg/errors"
	"net/http"
	"strings"
)

func ManufacturerInfoHandler(c buffalo.Context) error {
	req := models.ManufacturerReq{}
	err := json.NewDecoder(c.Request().Body).Decode(&req)
	if err != nil {
		return errors.WithStack(err)
	}
	var manufacturers []models.Manufacturer
	err = models.DB.Where(
		"lower(manufacturer) LIKE (?)",
		"%"+strings.ToLower(req.Manufacturer)+"%").All(&manufacturers)
	if err != nil {
		return errors.WithStack(err)
	}
	return c.Render(http.StatusOK, r.JSON(manufacturers))
}

func ManufacturerListHandler(c buffalo.Context) error {
	req := models.ManufacturerReq{}
	err := json.NewDecoder(c.Request().Body).Decode(&req)
	if err != nil {
		return errors.WithStack(err)
	}

	var manufacturers []models.ManufacturerInfo
	err = models.DB.
		RawQuery("SELECT * FROM find_manufacturer_goods((?)::varchar)", req.Manufacturer).
		All(&manufacturers)
	if err != nil {
		return errors.WithStack(err)
	}
	return c.Render(http.StatusOK, r.JSON(manufacturers))
}
