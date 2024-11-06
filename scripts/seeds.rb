
inbox = WcoEmail::Tag.find_or_create_by!({ slug: 'inbox' })

profile_victor_piousbox = Wco::Profile.find_or_create_by({ email: 'victor@piousbox.com' })
# profile_victor_piousbox = Wco::Profile.find_by({ email: 'victor@piousbox.com' })
