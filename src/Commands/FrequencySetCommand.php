<?php

namespace Pantheon\TerminusAutopilot\Commands;

use Pantheon\Terminus\Commands\TerminusCommand;
use Pantheon\Terminus\Request\RequestAwareInterface;
use Pantheon\Terminus\Site\SiteAwareInterface;
use Pantheon\Terminus\Site\SiteAwareTrait;
use Pantheon\TerminusAutopilot\AutopilotApi\AutopilotClientAwareTrait;

/**
 * Class FrequencySetCommand.
 */
class FrequencySetCommand extends TerminusCommand implements RequestAwareInterface, SiteAwareInterface
{
    use AutopilotClientAwareTrait;
    use SiteAwareTrait;

    /**
     * Set Autopilot run frequency for a specific site.
     *
     * @authorize
     * @filter-output
     *
     * @command site:autopilot:frequency
     * @aliases ap-frequency-set
     * @authorize
     * @filter-output
     *
     * @param string $site_id Long form site ID.
     * @param string $frequency Frequency for Terminus to run.
     *   Available options: MANUAL, MONTHLY, WEEKLY, DAILY.
     *
     * @return void
     *
     * @throws \GuzzleHttp\Exception\GuzzleException
     * @throws \Pantheon\Terminus\Exceptions\TerminusException
     * @throws \Psr\Container\ContainerExceptionInterface
     * @throws \Psr\Container\NotFoundExceptionInterface
     */
    public function autopilotFrequencySet(string $site_id, string $frequency,): void
    {
        $site = $this->getSite($site_id);

        try {
            $this->getClient()->setFrequency($site->id, $frequency);
        } catch (\Throwable $t) {
            $this->log()->error(
                'Autopilot frequency did not successfully update: {error_message}',
                ['error_message' => $t->getMessage()]
            );
            return;
        }

        $this->log()->success(
            'Autopilot frequency updated to {frequency}.',
            ['frequency' => strtoupper($frequency)]
        );
    }
}
