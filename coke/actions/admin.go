package actions

import (
	"coke/models"
	"github.com/pkg/errors"
	"net/http"

	"github.com/gobuffalo/buffalo"
)

func AdminMetaHandler(c buffalo.Context) error {
	var databases []models.PgDatabase
	if err := models.DB.All(&databases); err != nil {
		return errors.WithStack(err)
	}
	return c.Render(http.StatusOK, r.JSON(databases))
}
