package actions

import (
	"coke/models"
	"encoding/json"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v5"
	"github.com/pkg/errors"
	"net/http"
)

func ReviewsCountHandler(c buffalo.Context) error {
	req := models.ReviewStatsReq{}
	err := json.NewDecoder(c.Request().Body).Decode(&req)
	if err != nil {
		return errors.WithStack(err)
	}
	count, err := models.DB.Select(
		models.ReviewStats{}.GetRequest(req.Step, req.Low, req.High)...).
		Where(models.ReviewStats{}.GetWhere(req.Period)).
		GroupBy(models.ReviewStats{}.GetGroupBy(req.Step)).
		Count(models.ReviewStats{})
	if err != nil {
		return errors.WithStack(err)
	}
	return c.Render(http.StatusOK, r.JSON(count))
}

func ReviewsStatsHandler(c buffalo.Context) error {
	req := models.ReviewStatsReq{}
	err := json.NewDecoder(c.Request().Body).Decode(&req)
	if err != nil {
		return errors.WithStack(err)
	}
	var reviews []models.ReviewStats
	query := models.DB.Select(
		models.ReviewStats{}.GetRequest(req.Step, req.Low, req.High)...).
		Where(models.ReviewStats{}.GetWhere(req.Period)).
		GroupBy(models.ReviewStats{}.GetGroupBy(req.Step)).
		Order(models.ReviewStats{}.GetOrderBy(req.Step))
	sql, args := query.ToSQL(&pop.Model{Value: models.ReviewStats{}})
	query = query.RawQuery(sql, args...)
	if err = query.All(&reviews); err != nil {
		return errors.WithStack(err)
	}
	return c.Render(http.StatusOK, r.JSON(reviews))
}
