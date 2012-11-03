require 'spec_helper'

describe Guard::MochaNode::Runner do
  let(:runner) { Guard::MochaNode::Runner }

  before do
    Open3.stub(:popen3 => "response")
  end

  describe ".run" do
    context "when passed no paths" do
      it "returns false" do
        runner.run.should be_false
      end
    end

    context "when passed paths" do
      let(:some_paths) { %w(/foo/bar /zip/zap) }

      it "executes mocha node" do
        Open3.should_receive(:popen3).with(/__EXECUTABLE__/)
        runner.run(some_paths, :mocha_bin => "__EXECUTABLE__")
      end

      it "passes the paths to the executable" do
        Open3.should_receive(:popen3).with(/#{some_paths.join(" ")}/)
        runner.run(some_paths)
      end

      context "and coffeescript option is true" do
        it "passes the --coffee option to mocha node" do
          Open3.should_receive(:popen3).with(/--compilers coffee:coffee-script/)
          runner.run(some_paths, :coffeescript => true)
        end
      end

      context "and coffeescript option is false" do
        it "does not pass the --coffee option to mocha node" do
          Open3.should_not_receive(:popen3).with(/--coffee/)
          runner.run(some_paths, :coffeescript => false)
        end
      end

      context "and color option is true" do
        it "passes the -c option to mocha node" do
          Open3.should_receive(:popen3).with(/-c/)
          runner.run(some_paths, :color => true)
        end
      end

      context "and color option is false" do
        it "passes the -C option to mocha node" do
          Open3.should_receive(:popen3).with(/-C/)
          runner.run(some_paths, :color => false)
        end
      end

      context "and recursive option is true" do
        it "passes the --recursive option to mocha node" do
          Open3.should_receive(:popen3).with(/--recursive/)
          runner.run(some_paths, :recursive => true)
        end
      end

      context "and recursive option is false" do
        it "does not pass the --recursive option to mocha node" do
          Open3.should_not_receive(:popen3).with(/--recursive/)
          runner.run(some_paths, :recursive => false)
        end
      end

      it "returns IO object" do
        io_obj = double("io obj")
        Open3.stub(:popen3 => io_obj)
        runner.run(some_paths).should eql io_obj
      end

      context "when message option is given" do
        it "outputs message" do
          Guard::UI.should_receive(:info).with("hello", anything)
          runner.run(some_paths, :message => "hello")
        end
      end

      context "when no message option is given" do
        context "and running all specs" do
          it "outputs message confirming all specs are being run" do
            Guard::UI.should_receive(:info).with("Running all specs", anything)
            runner.run(Guard::MochaNode::PATHS_FOR_ALL_SPECS)
          end
        end

        context "and running some specs" do
          it "outputs paths of specs being run" do
            Guard::UI.should_receive(:info).with("Running: /foo/bar /zip/zap", anything)
            runner.run(some_paths)
          end
        end
      end
    end
  end
end
