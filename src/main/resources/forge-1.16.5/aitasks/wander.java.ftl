<#include "aiconditions.java.ftl">
this.goalSelector.addGoal(${cbi+1}, new RandomWalkingGoal(this, ${field$speed})<@conditionCode field$condition/>);
