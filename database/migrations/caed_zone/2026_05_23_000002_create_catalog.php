<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    protected $connection = 'caed_zone';

    public function up(): void
    {
        Schema::create('games', function (Blueprint $table) {
            $table->id();
            $table->string('code', 8)->unique();
            $table->string('name', 80);
            $table->string('icon_url', 255)->nullable();
            $table->timestamps();
        });

        Schema::create('sets', function (Blueprint $table) {
            $table->id();
            $table->foreignId('game_id')->constrained()->cascadeOnDelete();
            $table->string('code', 16);
            $table->string('name', 120);
            $table->date('release_date')->nullable();
            $table->timestamps();

            $table->unique(['game_id', 'code']);
        });

        Schema::create('shops', function (Blueprint $table) {
            $table->id();
            $table->foreignId('owner_user_id')->constrained('users')->cascadeOnDelete();
            $table->string('name', 120);
            $table->string('slug', 120)->unique();
            $table->string('logo_url', 255)->nullable();
            $table->text('description')->nullable();
            $table->decimal('gp_rate', 4, 2)->default(10.00);
            $table->enum('status', ['active', 'suspended'])->default('active');
            $table->timestamps();
        });

        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->foreignId('shop_id')->constrained()->cascadeOnDelete();
            $table->foreignId('game_id')->constrained();
            $table->foreignId('set_id')->nullable()->constrained();
            $table->string('name', 160);
            $table->enum('type', ['booster_pack', 'single_card', 'box', 'graded_card']);
            $table->enum('rarity', ['common', 'rare', 'sr', 'sar', 'alt', 'sec'])->nullable();
            $table->decimal('price', 10, 2);
            $table->unsignedInteger('stock')->default(0);
            $table->string('cover_url', 255)->nullable();
            $table->unsignedTinyInteger('psa_grade')->nullable();
            $table->enum('status', ['active', 'hidden', 'sold_out'])->default('active');
            $table->timestamps();

            $table->index(['shop_id', 'status']);
            $table->index(['game_id', 'set_id']);
        });

        Schema::create('product_serials', function (Blueprint $table) {
            $table->id();
            $table->foreignId('product_id')->constrained()->cascadeOnDelete();
            $table->string('serial_code', 40)->unique();
            $table->string('carton_no', 8)->nullable();
            $table->string('box_no', 8)->nullable();
            $table->string('pack_no', 8)->nullable();
            $table->enum('status', ['available', 'reserved', 'sold', 'queue_live', 'opened', 'delivered'])->default('available');
            $table->foreignId('owner_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();

            $table->index(['product_id', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('product_serials');
        Schema::dropIfExists('products');
        Schema::dropIfExists('shops');
        Schema::dropIfExists('sets');
        Schema::dropIfExists('games');
    }
};
