require "docker_helper"

### DOCKER_IMAGE ###############################################################

describe "Docker image", :test => :docker_image do
  # Default Serverspec backend
  before(:each) { set :backend, :docker }

  ### DOCKER_IMAGE #############################################################

  describe docker_image(ENV["DOCKER_IMAGE"]) do
    # Execute Serverspec command locally
    before(:each) { set :backend, :exec }
    it { is_expected.to exist }
  end

  ### OS #######################################################################

  describe "Operating system" do
    context "family" do
      # We can not simple test the os[:family] because CentOS is reported as "redhat"
      subject { file("/etc/centos-release") }
      it "sould eq \"centos\"" do
        expect(subject).to be_file
      end
    end
    context "locale" do
      context "CHARSET" do
        subject { command("echo ${CHARSET}") }
        it { expect(subject.stdout.strip).to eq("UTF-8") }
      end
      context "LANG" do
        subject { command("echo ${LANG}") }
        it { expect(subject.stdout.strip).to eq("en_US.UTF-8") }
      end
      context "LC_ALL" do
        subject { command("echo ${LC_ALL}") }
        it { expect(subject.stdout.strip).to eq("en_US.UTF-8") }
      end
    end
  end

  ### USERS ####################################################################

  describe "Users" do
    [
      # [user,                      uid,  primary_group]
      ["elasticsearch",             1000, "elasticsearch"],
    ].each do |user, uid, primary_group|
      context user(user) do
        it { is_expected.to exist }
        it { is_expected.to have_uid(uid) } unless uid.nil?
        it { is_expected.to belong_to_primary_group(primary_group) } unless primary_group.nil?
      end
    end
  end

  ### GROUPS ###################################################################

  describe "Groups" do
    [
      # [group,                     gid]
      ["elasticsearch",             1000],
    ].each do |group, gid|
      context group(group) do
        it { is_expected.to exist }
        it { is_expected.to have_gid(gid) } unless gid.nil?
      end
    end
  end

  ### PACKAGES #################################################################

  describe "Packages" do
    [
      # [package,                   version,                    installer]
      "bash",
    ].each do |package, version, installer|
      describe package(package) do
        it { is_expected.to be_installed }                        if installer.nil? && version.nil?
        it { is_expected.to be_installed.with_version(version) }  if installer.nil? && ! version.nil?
        it { is_expected.to be_installed.by(installer) }          if ! installer.nil? && version.nil?
        it { is_expected.to be_installed.by(installer).with_version(version) } if ! installer.nil? && ! version.nil?
      end
    end
  end

  ### COMMANDS #################################################################

  describe "Commands" do

    # [command, version, args]
    commands = [
      ["/usr/lib/jvm/jre/bin/java",         ENV["DOCKER_VERSION"], "-version"],
      ["/usr/share/elasticsearch/bin/elasticsearch",  ENV["DOCKER_VERSION"]],
    ]

    commands.each do |command, version, args|
      describe "Command \"#{command}\"" do
        subject { file(command) }
        let(:version_regex) { /\W#{version}\W/ }
        let(:version_cmd) { "#{command} #{args.nil? ? "--version" : "#{args}"}" }
        it "should be installed#{version.nil? ? nil : " with version \"#{version}\""}" do
          expect(subject).to exist
          expect(subject).to be_executable
          expect(command(version_cmd).stdout).to match(version_regex) unless version.nil?
        end
      end
    end
  end

  ### ELASTICSEARCH_FILES ######################################################

  describe "Files" do

    files = [
      # [
      #   file,
      #   mode, user, group, [expectations],
      #   rootfs, srcfile,
      #   match,
      # ]
      [
        "/docker-entrypoint.sh",
        755, "root", "root", [:be_file],
      ],
      [
        "/docker-entrypoint.d/30-elasticsearch-environment.sh",
        644, "root", "root", [:be_file, :eq_sha256sum],
      ],
      [
        "/docker-entrypoint.d/60-elasticsearch-fragments.sh",
        644, "root", "root", [:be_file, :eq_sha256sum],
      ],
      [
        "/docker-entrypoint.d/70-elasticsearch-settings.sh",
        644, "root", "root", [:be_file, :eq_sha256sum],
      ],
      [
        "/docker-entrypoint.d/80-elasticsearch-options.sh",
        644, "root", "root", [:be_file, :eq_sha256sum],
      ],
      [
        "/usr/share/elasticsearch",
        755, "root", "root", [:be_directory],
      ],
      [
        "/usr/share/elasticsearch/bin",
        755, "root", "root", [:be_directory],
      ],
      [
        "/usr/share/elasticsearch/config",
        750, "elasticsearch", "elasticsearch", [:be_directory],
      ],
      [
        "/usr/share/elasticsearch/config/elasticsearch.docker.yml",
        640, "elasticsearch", "elasticsearch", [:be_file],
      ],
      [
        "/usr/share/elasticsearch/config/elasticsearch.yml",
        640, "elasticsearch", "elasticsearch", [:be_file],
        nil, nil,
        "^# elasticsearch.docker.yml$"
      ],
      [
        "/usr/share/elasticsearch/data",
        750, "elasticsearch", "elasticsearch", [:be_directory],
      ],
      [
        "/usr/share/elasticsearch/logs",
        750, "elasticsearch", "elasticsearch", [:be_directory],
      ],
      [
        "/usr/share/elasticsearch/plugins",
        755, "root", "root", [:be_directory],
      ],
    ]

    if ENV["ELASTICSEARCH_TAG"].start_with?("2.") then
      files += [
        [
          "/docker-entrypoint.d/31-es2x-environment.sh",
          644, "root", "root", [:be_file, :eq_sha256sum],
          "#{ENV["ELASTICSEARCH_TAG"]}/rootfs",
        ],
        [
          "/docker-entrypoint.d/71-es2x-settings.sh",
          644, "root", "root", [:be_file, :eq_sha256sum],
          "#{ENV["ELASTICSEARCH_TAG"]}/rootfs",
        ],
        [
          "/usr/share/elasticsearch/config/logging.docker.yml",
          640, "elasticsearch", "elasticsearch", [:be_file, :eq_sha256sum],
          "#{ENV["ELASTICSEARCH_TAG"]}/rootfs",
        ],
        [
          "/usr/share/elasticsearch/config/logging.yml",
          640, "elasticsearch", "elasticsearch", [:be_file],
          nil, nil,
          "^# logging.docker.yml$",
        ],
      ]
    else
      files += [
        [
          "/usr/share/elasticsearch/config/log4j2.docker.properties",
          640, "elasticsearch", "elasticsearch", [:be_file, :eq_sha256sum],
        ],
        [
          "/usr/share/elasticsearch/config/log4j2.properties",
          640, "elasticsearch", "elasticsearch", [:be_file],
          nil, nil,
          "^# log4j2.docker.properties$",
        ],
        [
          "/usr/share/elasticsearch/config/jvm.default.options",
          640, "elasticsearch", "elasticsearch", [:be_file],
        ],
        [
          "/usr/share/elasticsearch/config/jvm.options",
          640, "elasticsearch", "elasticsearch", [:be_file],
          nil, nil,
          "^# jvm.default.options$"
        ],
      ]
    end

    files.each do |file, mode, user, group, expectations, rootfs, srcfile, match|
      expectations ||= []
      rootfs = "rootfs" if rootfs.nil?
      srcfile = file if srcfile.nil?
      context file(file) do
        it { is_expected.to exist }
        it { is_expected.to be_file }       if expectations.include?(:be_file)
        it { is_expected.to be_directory }  if expectations.include?(:be_directory)
        it { is_expected.to be_mode(mode) } unless mode.nil?
        it { is_expected.to be_owned_by(user) } unless user.nil?
        it { is_expected.to be_grouped_into(group) } unless group.nil?
        its(:content) { is_expected.to match(match) } unless match.nil?
        its(:sha256sum) do
          is_expected.to eq(
            Digest::SHA256.file("#{rootfs}#{srcfile}").to_s
          )
        end if expectations.include?(:eq_sha256sum)
      end
    end
  end

  ### XPACK_FILES ##############################################################

  describe "X-Pack Files", :test => :docker_image, :x_pack => true do
    [
      # [
      #   file,
      #   mode, user, group, [expectations],
      #   rootfs, srcfile,
      #   match,
      # ]
      [
        "/docker-entrypoint.d/32-x-pack-environment.sh",
        644, "root", "root", [:be_file, :eq_sha256sum],
        "x-pack/rootfs",
      ],
      [
        "/docker-entrypoint.d/62-x-pack-fragments.sh",
        644, "root", "root", [:be_file, :eq_sha256sum],
        "x-pack/rootfs",
      ],
      [
        "/docker-entrypoint.d/72-x-pack-settings.sh",
        644, "root", "root", [:be_file, :eq_sha256sum],
        "x-pack/rootfs",
      ],
      [
        "/usr/share/elasticsearch/config/elasticsearch.x-pack.basic.yml",
        640, "elasticsearch", "elasticsearch", [:be_file, :eq_sha256sum],
        "#{ENV["ELASTICSEARCH_TAG"]}/x-pack/rootfs"
      ],
      [
        "/usr/share/elasticsearch/config/elasticsearch.x-pack.gold.yml",
        640, "elasticsearch", "elasticsearch", [:be_file, :eq_sha256sum],
        "#{ENV["ELASTICSEARCH_TAG"]}/x-pack/rootfs"
      ],
      [
        "/usr/share/elasticsearch/config/elasticsearch.x-pack.platinum.yml",
        640, "elasticsearch", "elasticsearch", [:be_file, :eq_sha256sum],
        "#{ENV["ELASTICSEARCH_TAG"]}/x-pack/rootfs"
      ],
      [
        "/usr/share/elasticsearch/config/elasticsearch.x-pack.yml",
        640, "elasticsearch", "elasticsearch", [:be_file],
        "x-pack/rootfs",
      ],
      [
        "/usr/share/elasticsearch/config/elasticsearch.yml",
        640, "elasticsearch", "elasticsearch", [:be_file],
        nil, nil,
        [
          "^# elasticsearch.docker.yml$",
          "^# elasticsearch.x-pack.yml$",
          "^# elasticsearch.x-pack.platinum.yml$",
        ]
      ],
      [
        "/usr/share/elasticsearch/config/elasticsearch.keystore",
        640, "elasticsearch", "elasticsearch", [:be_file],
      ],[
        "/usr/share/elasticsearch/config/x-pack/log4j2.docker.properties",
        640, "elasticsearch", "elasticsearch", [:be_file, :eq_sha256sum],
        "x-pack/rootfs",
      ],
      [
        "/usr/share/elasticsearch/config/x-pack/log4j2.properties",
        640, "elasticsearch", "elasticsearch", [:be_file],
        nil, nil,
        "^# log4j2.docker.properties$"
      ],
      [
        "/usr/share/elasticsearch/plugins/x-pack/x-pack-#{ENV["ELASTICSEARCH_VERSION"]}.jar",
        644, "root", "root", [:be_file],
      ],
    ].each do |file, mode, user, group, expectations, rootfs, srcfile, match|
      expectations ||= []
      rootfs = "rootfs" if rootfs.nil?
      srcfile = file if srcfile.nil?
      context file(file) do
        it { is_expected.to exist }
        it { is_expected.to be_file }       if expectations.include?(:be_file)
        it { is_expected.to be_directory }  if expectations.include?(:be_directory)
        it { is_expected.to be_mode(mode) } unless mode.nil?
        it { is_expected.to be_owned_by(user) } unless user.nil?
        it { is_expected.to be_grouped_into(group) } unless group.nil?
        case match
        when String
          its(:content) { is_expected.to match(match) }
        when Array
          match.each do |m|
            its(:content) { is_expected.to match(m) }
          end
        end
        its(:sha256sum) do
          is_expected.to eq(
            Digest::SHA256.file("#{rootfs}/#{srcfile}").to_s
          )
        end if expectations.include?(:eq_sha256sum)
      end
    end
  end

  ##############################################################################

end

################################################################################
