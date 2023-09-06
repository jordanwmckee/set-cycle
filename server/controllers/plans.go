package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jordanwmckee/sets-app/models"
	"github.com/jordanwmckee/sets-app/utils/token"
)

// GetPlans returns all plans from the database for the current user
func GetPlans(c *gin.Context) {
	// get user id from token
	user_id, err := token.ExtractTokenID(c)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// now get all plans for this user using the user id
	plans, err := models.GetPlans(user_id)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, plans)
}

// CreatePlan takes a plan object and saves it to the database
func CreatePlan(c *gin.Context) {
	// get user id from token
	user_id, err := token.ExtractTokenID(c)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var plan models.Plan

	if err := c.ShouldBindJSON(&plan); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}

	_, err = plan.CreateNewPlanForUser(user_id)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, plan)
}

// ModifyPlan takes a plan object and saves it to the database
func ModifyPlan(c *gin.Context) {
	// get user id from token
	user_id, err := token.ExtractTokenID(c)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid token"})
		return
	}

	// get plan id from request
	plan_id, err := models.ExtractPlanID(c)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// create Plan object from request
	var plan models.Plan

	if err := c.ShouldBindJSON(&plan); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}

	// Make request to DB to modify the plan
	plan.UserID = user_id
	plan.ID = plan_id

	_, err = plan.ModifyPlanForUser(user_id)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, plan)
}

// DeletePlan deletes a plan from the database
func DeletePlan(c *gin.Context) {
	// get user id from token
	uid, err := token.ExtractTokenID(c)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// get plan id from request
	pid, err := models.ExtractPlanID(c)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// try to delete the plan
	err = models.DeletePlanForUser(uid, pid)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "plan deleted successfully"})
}
