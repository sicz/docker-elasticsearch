require "docker_helper"

### DOCKER_CONTAINER ###########################################################

describe "Docker container", :test => :docker_container do
  # Default Serverspec backend
  before(:each) { set :backend, :docker }

  ### DOCKER_CONTAINER #########################################################

  describe docker_container(ENV["CONTAINER_NAME"]) do
    # Execute Serverspec command locally
    before(:each) { set :backend, :exec }
    it { is_expected.to be_running }
  end

  ### PROCESSES ################################################################

  describe "Processes" do
    [
      # [process,                   user,             group,            pid]
      ["tini",                      "root",           "root",           1],
      ["java",                      "elasticsearch",  "elasticsearch"],
    ].each do |process, user, group, pid|
      context process(process) do
        it { is_expected.to be_running }
        its(:pid) { is_expected.to eq(pid) } unless pid.nil?
        its(:user) { is_expected.to eq(user) } unless user.nil?
        its(:group) { is_expected.to eq(group) } unless group.nil?
      end
    end
  end

  ### PORTS ####################################################################

  # TODO: Specinfra due the bug is not able to test listening ports
  describe "Ports" do
    [
      # [port, proto]
      [9200, "tcp"],
      [9300, "tcp"],
    ].each do |port, proto|
      context port(port) do
        it { is_expected.to be_listening.with(proto) }
      end
    end
  end

  ### ELASTICSEARCH ############################################################

  describe "Elasticsearch endpoint" do
    # Execute Serverspec commands locally
    before(:each)  { set :backend, :exec }
    [
      # [url, stdout, stderr, user, passwd]
      [
        "#{ENV["ELASTICSEARCH_URL"]}",
        "\"number\" : \"#{ENV["ELASTICSEARCH_VERSION"]}\"",
        "^< Content-Type: application\\/json; charset=UTF-8\\r$",
        "elastic", "changeme",
      ],
      [
        "#{ENV["ELASTICSEARCH_URL"]}/_cluster/health",
        "\"status\":\"(green|yellow)\"",
        "^< Content-Type: application\\/json; charset=UTF-8\\r$",
        "elastic", "changeme",
      ],
    ].each do |url, stdout, stderr, user, passwd|
      context url do
        subject { command("curl --location --silent --show-error --verbose --user #{user}:#{passwd} #{url}") }
        it "should exist" do
          expect(subject.exit_status).to eq(0)
        end
        it "should match /#{stdout}/" do
          expect(subject.stdout).to match(/#{stdout}/i)
        end unless stdout.nil?
        it "should match /#{stderr}/" do
          expect(subject.stderr).to match(/#{stderr}/i)
        end unless stderr.nil?
      end
    end
  end

  ##############################################################################

end
