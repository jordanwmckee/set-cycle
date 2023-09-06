package main

import (
	// local packages
	"github.com/jordanwmckee/sets-app/controllers"
	"github.com/jordanwmckee/sets-app/middlewares"
	"github.com/jordanwmckee/sets-app/models"
	"github.com/jordanwmckee/sets-app/utils/db"

	// external packages
	"github.com/gin-gonic/gin"
)

func main() {
	// connect and initialize database
	dbConnection, err := models.ConnectDatabase()

	// initialize db instance
	db.Initialize(dbConnection)

	if err != nil {
		panic(err)
	}

	r := gin.Default()

	// public routes
	public := r.Group("/api")
	public.POST("/register", controllers.Register)
	public.POST("/login", controllers.Login)
	public.POST("/refresh", controllers.RefreshToken)

	// protected users route
	users := r.Group("/api/users")
	users.Use(middlewares.JwtAuthMiddleware())
	users.GET("/me", controllers.CurrentUser)
	users.DELETE("/me", controllers.DeleteUser)

	// protected plans route
	plans := r.Group("/api/plans")
	plans.Use(middlewares.JwtAuthMiddleware())
	plans.GET("/", controllers.GetPlans)
	plans.DELETE("/:plan_id", controllers.DeletePlan)
	plans.POST("/create", controllers.CreatePlan)
	plans.PUT("/modify/:plan_id", controllers.ModifyPlan)

	r.Run(":8080")

}
