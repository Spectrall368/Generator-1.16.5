<#include "aiconditions.java.ftl">
this.goalSelector.addGoal(${cbi+1}, new WaterAvoidingRandomWalkingGoal(this, ${field$speed})<@conditionCode field$condition/>);
