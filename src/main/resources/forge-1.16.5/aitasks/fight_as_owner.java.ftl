<#if (data.tameable && data.breedable)>
<#include "aiconditions.java.ftl">
this.goalSelector.addGoal(${cbi+1}, new OwnerHurtTargetGoal(this)<@conditionCode field$condition/>);
</#if>
