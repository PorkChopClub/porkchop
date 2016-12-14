const matchField = (field) =>
  (match) =>
    match
      .filter((match) => !!match)
      .map(field)
      .skipDuplicates()

export const homeScore = matchField('.home_score')
export const awayScore = matchField('.away_score')

export const homeName = matchField('.home_player.name')
export const awayName = matchField('.away_player.name')

export const homePortrait = matchField('.home_player.portrait_url')
export const awayPortrait = matchField('.away_player.portrait_url')

const serviceState = (field) =>
  (match) => matchField(field)(match).map((value) => {
    switch (value) {
      case true:
        return 'serving'
      case false:
        return 'receiving'
      case null:
        return 'no-service'
    }
  })

export const homeServiceState = serviceState('.home_service')
export const awayServiceState = serviceState('.away_service')
