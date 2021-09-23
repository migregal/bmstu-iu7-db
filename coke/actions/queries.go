package actions

import (
	"coke/models"
	"encoding/json"
	"github.com/gobuffalo/pop/v5"
	"github.com/pkg/errors"
	"net/http"
	"strings"

	"github.com/gobuffalo/buffalo"
)

func CompaniesHandler(c buffalo.Context) error {
	req := models.ShopReq{}
	err := json.NewDecoder(c.Request().Body).Decode(&req)
	if err != nil {
		return errors.WithStack(err)
	}
	var shops []models.Shop
	err = models.DB.Where(
		"lower(company) LIKE (?)",
		"%"+strings.ToLower(req.Company)+"%").All(&shops)
	if err != nil {
		return errors.WithStack(err)
	}
	return c.Render(http.StatusOK, r.JSON(shops))
}

func ShopsHandler(c buffalo.Context) error {
	req := models.ShopReq{}
	err := json.NewDecoder(c.Request().Body).Decode(&req)
	if err != nil {
		return errors.WithStack(err)
	}
	var shops []models.Shop
	err = models.DB.Where(
		"lower(company) LIKE (?) AND lower(name) LIKE (?)",
		"%"+strings.ToLower(req.Company)+"%",
		"%"+strings.ToLower(req.Shop)+"%").All(&shops)
	if err != nil {
		return errors.WithStack(err)
	}
	return c.Render(http.StatusOK, r.JSON(shops))
}

func EmployeesHandler(c buffalo.Context) error {
	req := models.EmployeeReq{}
	err := json.NewDecoder(c.Request().Body).Decode(&req)
	if err != nil {
		return errors.WithStack(err)
	}

	query := models.DB.Q().LeftJoin("shops s", "s.id = employees.shop_id").
		LeftJoin("reviews r", "r.employee_id = employees.id").
		Where("s.company LIKE (?) AND s.name LIKE (?)", "%"+req.Company+"%", "%"+req.Shop+"%").
		GroupBy("s.company, employees.job, employees.first_name, employees.last_name").
		Order("employees.last_name, employees.first_name").
		Paginate(req.Page, req.PerPage)

	sql, args := query.ToSQL(&pop.Model{Value: models.Employee{}},
		"s.company",
		"employees.job",
		"employees.first_name",
		"employees.last_name",
		"ROUND(COALESCE(AVG(r.employee_rating), 0.0)::numeric,2) as rating")

	var employees []models.Employee
	query = query.RawQuery(sql, args...)
	err = query.All(&employees)
	if err != nil {
		return errors.WithStack(err)
	}
	return c.Render(http.StatusOK, r.JSON(employees))
}

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
