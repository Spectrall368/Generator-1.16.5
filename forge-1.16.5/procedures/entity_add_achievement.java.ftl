if(${input$entity} instanceof ServerPlayerEntity) {
	Advancement _adv = ((ServerPlayerEntity)${input$entity}).server.getAdvancementManager().getAdvancement(new ResourceLocation("${generator.map(field$achievement, "achievements")}"));
    AdvancementProgress _ap = ((ServerPlayerEntity) ${input$entity}).getAdvancements().getProgress(_adv);
    if (!_ap.isDone()) {
        Iterator _iterator = _ap.getRemaningCriteria().iterator();
        while(_iterator.hasNext())
            ((ServerPlayerEntity) ${input$entity}).getAdvancements().grantCriterion(_adv, (String)_iterator.next());
    }
}
