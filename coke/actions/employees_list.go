package actions

import (
	"coke/models"
	"encoding/json"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v5"
	"github.com/pkg/errors"
	"net/http"
	"strings"
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
