# rubocop:disable Lint/EmptyBlock
class Thunderbird
  RSpec.describe Mbox, type: :aruba do
    subject { described_class.new(path: mailbox_path) }

    let(:index_path) { "some/path/mbox.msf" }
    let(:mailbox_path) { "some/path/mbox" }
    let(:mailbox_exists) { true }
    let(:index_exists) { true }
    let(:mork) { instance_double(Mork::Parser, data: data) }
    let(:data) { instance_double(Mork::Data, tables: tables) }
    let(:tables) do
      {
        "ns:msg:db:row:scope:msgs:all" => {
          "1" => {
            "msg1" => {"offlineMsgSize" => message_first.length.to_s(16), "msgOffset" => "0"},
            "msg2" => {"offlineMsgSize" => message_second.length.to_s(16),
                       "msgOffset" => message_first.length.to_s(16)}
          }
        }
      }
    end
    let(:file) { instance_double(File) }
    let(:message_first) { "From - Thu Jan 01 00:00:00 1970\nThe first message is longer" }
    let(:message_second) { "From - Thu Jan 02 00:00:00 1970\n" }

    before do
      allow(File).to receive(:open).and_call_original
      allow(File).to receive(:open).with(mailbox_path) do |&block|
        if !mailbox_exists
          raise Errno::ENOENT, "No such file or directory @ rb_sysopen - #{mailbox_path}"
        end

        block.call(file)
      end
      allow(File).to receive(:read).and_call_original
      allow(File).to receive(:read).with(index_path) do
        if !index_exists
          raise Errno::ENOENT, "No such file or directory @ rb_sysopen - #{index_path}"
        end

        "index_content"
      end
      allow(Mork::Parser).to receive(:new) { mork }
      allow(file).to receive(:read).with(message_first.length) { message_first }
      allow(file).to receive(:read).with(message_second.length) { message_second }
    end

    describe "#each" do
      it "yields messages" do
        expect { |b| subject.each(&b) }.
          to yield_successive_args(["msg1", message_first], ["msg2", message_second])
      end

      context "when the file does not exist" do
        let(:mailbox_exists) { false }

        it "raises an error" do
          expect do
            subject.each {}
          end.to raise_error(Errno::ENOENT)
        end
      end

      context "when the folder index does not exist" do
        let(:index_exists) { false }

        it "raises an error" do
          expect do
            subject.each {}
          end.to raise_error(Errno::ENOENT)
        end
      end
    end
  end
end
# rubocop:enable Lint/EmptyBlock
