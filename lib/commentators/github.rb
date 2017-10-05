# frozen_string_literal: true

module Commentators
  class Github
    STATUS = 'COMMENT'

    def initialize(config)
      @config = config
    end

    def call(violations)
      comments = violations.map do |violation|
        next if commented?(violation)
        generate_comment(violation)
      end.compact
      Utils.octokit
           .create_pull_request_review(@config.repo, @config.id,
                                       event: STATUS, comments: comments)
    end

    private

    def commented?(violation)
      commented_violations.find do |commented_violation|
        [
          violation.filename == commented_violation[:path],
          violation.line.patch_position == commented_violation[:position],
          Utils.similarity(
            violation.message, commented_violation[:body]
          ) > 0.9
        ].all?
      end
    end

    def commented_violations
      @commented_violations ||=
        Utils.octokit.pull_request_comments(@config.repo, @config.id)
    end

    def generate_comment(violation)
      {
        body: violation.message,
        path: violation.filename,
        position: violation.line.patch_position
      }
    end
  end
end
