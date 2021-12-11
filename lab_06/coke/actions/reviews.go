package actions

import (
	"coke/models"
	"encoding/json"
	"net/http"

	"github.com/gobuffalo/buffalo"
	"github.com/pkg/errors"
)

func ReviewsInsertionHandler(c buffalo.Context) error {
	req := []models.ReviewInfo{}
	err := json.NewDecoder(c.Request().Body).Decode(&req)
	if err != nil {
		return errors.WithStack(err)
	}

	for _, review := range req {
		err = models.DB.
			RawQuery("INSERT INTO"+
				" reviews(reviewer_id,shop_id,good_id,employee_id,good_rating,shop_rating,employee_rating)"+
				" VALUES ((?)::UUID,(?)::UUID,(?)::UUID,(?)::UUID,(?),(?),(?))",
				review.ReviewerId,
				review.ShopId,
				review.GoodId,
				review.EmployeeId,
				review.GoodRating,
				review.ShopRating,
				review.EmployeeRating).
			Exec()
		if err != nil {
			return errors.WithStack(err)
		}
	}

	redis.Client.FlushAll(ctx)
	return c.Render(http.StatusOK, r.JSON(nil))
}

func ReviewsDeleteHandler(c buffalo.Context) error {
	req := []models.ReviewInfo{}
	err := json.NewDecoder(c.Request().Body).Decode(&req)
	if err != nil {
		return errors.WithStack(err)
	}

	for _, review := range req {
		err = models.DB.
			RawQuery("DELETE FROM reviews WHERE id IN "+
				"(SELECT id FROM reviews WHERE reviewer_id = (?)::UUID LIMIT 10)",
				review.ReviewerId).
			Exec()
		if err != nil {
			return errors.WithStack(err)
		}
	}

	redis.Client.FlushAll(ctx)
	return c.Render(http.StatusOK, r.JSON(nil))
}
