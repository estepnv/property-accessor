require 'spec_helper'

RSpec.describe '.property' do
  let(:test_class) do
    Class.new do
      extend PropertyAccessor

      property(:foo) do
        get { @foo }
        set { |val| @foo = val }
      end
    end
  end

  it 'sets the property' do
    instance = test_class.new
    instance.foo = 'bar'
    expect(instance.foo).to eq 'bar'
  end

  context 'when getter is not defined' do
    let(:test_class) do
      Class.new do
        extend PropertyAccessor::ClassMethods

        property(:foo) do
          set { |val| @foo = val }
        end

        def get_foo
          @foo
        end
      end
    end

    it 'sets the setter only' do
      instance = test_class.new
      instance.foo = 'bar'
      expect(instance.get_foo).to eq 'bar'
      expect(instance.respond_to?(:foo)).to eq false
    end
  end

  context 'when setter is not defined' do
    let(:test_class) do
      Class.new do
        extend PropertyAccessor::ClassMethods

        property(:foo) do
          get { @foo }
        end

        def set_foo(val)
          @foo = val
        end
      end
    end

    it 'sets the getter only' do
      instance = test_class.new
      instance.set_foo('bar')
      expect(instance.foo).to eq 'bar'
      expect(instance.respond_to?(:foo=)).to eq false
    end
  end

  context 'when nothing is not defined' do
    let(:test_class) do
      Class.new do
        extend PropertyAccessor::ClassMethods

        property(:foo)

        def set_foo(val)
          @foo = val
        end
      end
    end

    it 'raises error' do
      instance = test_class.new
      expect(true).to eq false
    rescue PropertyAccessor::UndefinedPropertyError
    end
  end

  context 'with patched object' do
    let(:test_class) do
      Class.new do
        property(:foo) do
          get { @foo }
          set { |val| @foo = val }
        end
      end
    end

    it 'sets the property' do
      PropertyAccessor::Mixin.inject!
      instance = test_class.new
      instance.foo = 'bar'
      expect(instance.foo).to eq 'bar'
    end
  end
end
