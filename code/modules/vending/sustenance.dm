/obj/machinery/vending/sustenance
	name = "\improper Sustenance Vendor"
	desc = "A vending machine which vends the bare minimum the Pre-Fall US government considered food, made by Vault-tec."
	//product_slogans = "Enjoy your meal.;Enough calories to support strenuous labor."
	product_ads = "Sufficiently healthy.;Efficiently produced tofu!;Mmm! So good!;Have a meal.;You need food to live!;Have some more candy corn!;Try our new ice cups!"
	icon_state = "sustenance"
	products = list(/obj/item/reagent_containers/food/snacks/tofu = 24,
					/obj/item/reagent_containers/food/drinks/ice/sustanance = 12,
					/obj/item/reagent_containers/food/snacks/candy_corn = 6)
	contraband = list(/obj/item/kitchen/knife = 6,
					/obj/item/reagent_containers/food/drinks/coffee = 12,
					/obj/item/tank/internals/emergency_oxygen = 6,
					/obj/item/clothing/mask/breath = 6)
	armor = ARMOR_VALUE_HEAVY
	refill_canister = /obj/item/vending_refill/sustenance
	resistance_flags = FIRE_PROOF
	default_price = PRICE_FREE
	extra_price = PRICE_FREE
	payment_department = NO_FREEBIES

/obj/item/vending_refill/sustenance
	icon_state = "refill_cook"
