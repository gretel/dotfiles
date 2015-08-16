#
# Full brew and brew cask upgrade cycle in https://github.com/benjaminoakes/maid
#
Maid.rules do

  ### Homebrew:

  rule 'Updating brew formulas' do
    log(`brew update`)
  end

  rule 'Upgrading installed brew formulas' do
    log(`brew upgrade -all`)
  end

  rule 'Cleaning brew' do
    log(`brew cleanup`)
  end

  #Get all installed brew casks
  installedCasks = (`brew cask list`).split()

  # Upgrade casks, that have a version number other than latest
  # Inspiration from https://github.com/caskroom/homebrew-cask/issues/4678#issuecomment-77692503
  rule 'Update brew casks' do
    updateHappened = false

    installedCasks.each do |cask|
      needToInstall = system("brew cask info #{cask} |grep -qF 'Not installed'")
      if needToInstall
        updateHappened = true
        log("New Version of homebrew cask #{cask}, will install it")
        log(`brew cask install #{cask}`)
      end
    end

    log('No brew cask updated') unless updateHappened
  end

  # Delete old cask versions
  # Inspiration from https://gist.github.com/orangeudav/26a8752ae54a169b8516
  rule 'Clean brew casks' do

    log(`brew cask cleanup`)

    installedCasks.each do |cask|

      # Get installed version folders for each installed cask
      versions = dir("/opt/homebrew-cask/Caskroom/#{cask}/*")

      # Jump to next if only one version is installed
      next if versions.size == 1

      # Sort version folders by creation date
      versions.sort_by! do |item|
        created_at(item)
      end

      # Remove newest version folder from list
      currVer = versions.pop
      log("We won't delete newest version (#{currVer}) of #{cask}")

      # Trash all remaining versions
      versions.each do |version|
        trash(version)
      end

    end
  end

end
