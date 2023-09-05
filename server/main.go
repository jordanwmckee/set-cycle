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
	public.POST("/refresh", controllers.RefreshToken)

	users := r.Group("/api/users")
	users.Use(middlewares.JwtAuthMiddleware())
	users.GET("/me", controllers.CurrentUser)
	users.DELETE("/me", controllers.DeleteUser)

	r.Run(":8080")

}
