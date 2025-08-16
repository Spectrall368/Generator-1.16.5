private static Item getRandomItem(ResourceLocation name) {
		ITag<Item> tag = ItemTags.createOptional(name);
		return tag.getAllElements().isEmpty() ? Items.AIR : tag.getRandomElement(new Random());
}