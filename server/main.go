package main

import (
	// local packages
	"github.com/jordanwmckee/sets-app/controllers"
	"github.com/jordanwmckee/sets-app/middlewares"
	"github.com/jordanwmckee/sets-app/models"

	// external packages
	"github.com/gin-gonic/gin"
)

func main() {

	models.ConnectDatabase()

	r := gin.Default()

	public := r.Group("/api")

	public.POST("/register", controllers.Register)
	public.POST("/login", controllers.Login)

	protected := r.Group("/api/admin")
	protected.Use(middlewares.JwtAuthMiddleware())
	protected.GET("/user", controllers.CurrentUser)

	r.Run(":8080")

}
