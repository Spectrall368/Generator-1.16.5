if(${input$entity} instanceof ServerPlayerEntity) {
	Advancement _adv = ((ServerPlayerEntity)${input$entity}).server.getAdvancementManager().getAdvancement(new ResourceLocation("${generator.map(field$achievement, "achievements")}"));
    AdvancementProgress _ap = ((ServerPlayerEntity) ${input$entity}).getAdvancements().getProgress(_adv);
	if (!_ap.isDone()) {
		for (String criteria : _ap.getRemaningCriteria())
            ((ServerPlayerEntity) ${input$entity}).getAdvancements().grantCriterion(_adv, criteria);
    }
}
