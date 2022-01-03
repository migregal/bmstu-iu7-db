package actions

import (
	"coke/models"
	"encoding/json"
	"io/ioutil"
	"net/http"
	"time"

	"github.com/go-redis/cache/v8"

	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v5"
	"github.com/pkg/errors"
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
	jsonData, err := ioutil.ReadAll(c.Request().Body)
	if err != nil {
		return errors.WithStack(err)
	}

	var reviews []models.ReviewStats
	if c.Request().URL.Query().Get("cached") != "" {
		if err := redis.Cache.Get(
			ctx,
			string(jsonData),
			&reviews); err == nil && len(reviews) > 0 {
			return c.Render(http.StatusOK, r.JSON(reviews))
		}
	}

	req := models.ReviewStatsReq{}
	if err = json.Unmarshal(jsonData, &req); err != nil {
		return errors.WithStack(err)
	}

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

	if c.Request().URL.Query().Get("cached") != "" {
		if err := redis.Cache.Set(&cache.Item{
			Ctx:   ctx,
			Key:   string(jsonData),
			Value: reviews,
			TTL:   time.Hour,
		}); err != nil {
			return errors.WithStack(err)
		}
	}

	return c.Render(http.StatusOK, r.JSON(reviews))
}
