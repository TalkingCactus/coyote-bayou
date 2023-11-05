//Helpers to generate lists for filter helpers
//This is the only practical way of writing these that actually produces sane lists
/proc/alpha_mask_filter(x, y, icon/icon, render_source, flags)
	. = list("type" = "alpha")
	if(!isnull(x))
		.["x"] = x
	if(!isnull(y))
		.["y"] = y
	if(!isnull(icon))
		.["icon"] = icon
	if(!isnull(render_source))
		.["render_source"] = render_source
	if(!isnull(flags))
		.["flags"] = flags

atom/proc/ClearFilters()
	QDEL_LIST(filters)
	filters = list()

atom/proc/InitialFilters()
	filters = initial(filters)

/**
 * mythreshold - Color threshold for bloom,
 * mysize - Blur radius of bloom effect (see Gaussian blur),
 * myoffset - Growth/outline radius of bloom effect before blur,
 * myalpha - Opacity of effect (default is 255, max opacity)
*/
atom/proc/FilterBloom(mythreshold, mysize, myoffset, myalpha)
	filters += filter(type = "bloom", threshold = mythreshold, size = mysize, offset = myoffset, alpha = myalpha)

/// Do not go over 6 (you can't I won't let you)
atom/proc/FilterGaussianBlur(mysize)
	mysize = clamp(mysize, 0, 6)
	filters += filter(type = "radial_blur", size = mysize)
