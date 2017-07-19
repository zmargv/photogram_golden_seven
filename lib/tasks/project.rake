namespace :project do
  desc "Attempt to update project, if there are no conflicts"
  task :update do
    if `git config remote.upstream.url`.blank?
      `git remote add upstream git@github.com:appdevsummer17/photogram_golden_seven.git`
    end

    `git add -A`
    `git commit -m "Commit current changes"`
    `git fetch upstream`
    `git checkout master`
    `git reset --hard upstream/master`
    `git checkout -`
    `git rebase upstream/master`
    `bundle install`
    `git add -A`
    `git commit -m "Updated project from upstream"`
  end
end
